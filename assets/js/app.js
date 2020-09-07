// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.  import "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "../css/app.scss";
import "alpinejs";
import "phoenix_html";
import $ from "jquery";
import "select2/dist/js/select2.full.js";
import { Socket } from "phoenix";
import NProgress from "nprogress";
import { LiveSocket } from "phoenix_live_view";
import flatpickr from "flatpickr";
import {toCurrency} from "./currency-conversion";

let Hooks = {};
Hooks.DatePicker = {
  mounted() {
    this.setupDatePicker(this.el);
  },

  updated() {
    this.setupDatePicker(this.el);
  },

  setupDatePicker(el) {
    flatpickr(el, {
      altInput: true,
      defaultDate: new Date(),
      enableTime: false,
    })
  }
}
Hooks.SelectAccount = {
  initSelect2() {
    let hook = this,
      $select = $(hook.el).find("select");

    $select
      .select2({
        placeholder: {
          id: -1,
          text: "Account",
        },
        width: "100%",
        containerCssClass: "select2-custom-container-css",
        dropdownCssClass: "border-gray-300-important",
      })
      .on("select2:select", (e) => hook.selected(hook, e));

    return $select;
  },

  mounted() {
    this.initSelect2();
  },

  selected(hook, event) {
    let id = event.params.data.id;
    hook.pushEventTo(".select-account-div", "account-selected", {
      account_id: id,
    });
  },
};
Hooks.SelectCategory = {
  initSelect2() {
    let hook = this,
      $select = $(hook.el).find("select");

    $select
      .select2({
        placeholder: {
          id: -1,
          text: "Category",
        },
        width: "100%",
        containerCssClass: "select2-custom-container-css",
        dropdownCssClass: "border-gray-300-important",
      })
      .on("select2:select", (e) => hook.selected(hook, e));

    return $select;
  },

  mounted() {
    this.initSelect2();
  },

  selected(hook, event) {
    let id = event.params.data.id;
    hook.pushEventTo(".select-category-div", "category-selected", {
      category_id: id,
    });
  },
};
Hooks.SelectPayee = {
  initSelect2() {
    let hook = this,
      $select = $(hook.el).find("select");

    $select
      .select2({
        tags: true,
        placeholder: {
          id: "Payee",
          text: "Payee",
        },
        width: "100%",
        containerCssClass: "select2-custom-container-css",
        dropdownCssClass: "border-gray-300-important",
      })
      .on("select2:select", (e) => hook.selected(hook, e));

    return $select;
  },

  mounted() {
    this.initSelect2();
  },

  selected(hook, event) {
    let payee = event.params.data.id;
    hook.pushEventTo(".select-payee-div", "payee-selected", { payee: payee });
  },
};
Hooks.DelayedCloseModal = {
  mounted() {
    const handleCloseEventListener = () => {
      this.el.removeEventListener("close-modal", handleCloseEventListener);
      this.pushEvent("close-modal");
    };

    this.el.addEventListener("close-modal", handleCloseEventListener);
  },
};
Hooks.CurrencyMask = {
  mounted() {
    this.el.addEventListener("input", _ => {
      this.el.value = toCurrency(this.el.value);
    });
  }
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        window.Alpine.clone(from.__x, to);
      }
    },
  },
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", (_) => NProgress.start());
window.addEventListener("phx:page-loading-stop", (_) => NProgress.done());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket;

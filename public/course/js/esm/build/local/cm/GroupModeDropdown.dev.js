var __defProp = Object.defineProperty;
var __name = (target, value) => __defProp(target, "name", { value, configurable: true });
import { jsxDEV } from "react/jsx-dev-runtime";
/**
 * Activity group mode dropdown displayed on every activity card in edit mode.
 *
 * @module     core_course/local/cm/GroupModeDropdown
 * @copyright  2026 Yusuf Wibisono <yusuf.wibisono@moodle.com>
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */
import { useEffect, useRef, useState } from "react";
import { Dropdown, DropdownItemSelect, DropdownTrigger } from "@moodlehq/design-system";
import { requireAsync } from "@moodle/lms/core/amd";
import Pending from "@moodle/lms/core/pending";
const pendingFocus = /* @__PURE__ */ new Set();
function GroupModeDropdown({ cmid, value, options }) {
  const [open, setOpen] = useState(false);
  const [current, setCurrent] = useState(value);
  const dropdownRef = useRef(null);
  const itemRefs = useRef([]);
  const getTrigger = /* @__PURE__ */ __name(() => dropdownRef.current?.querySelector(".groupmode-trigger"), "getTrigger");
  useEffect(() => {
    if (pendingFocus.delete(cmid)) {
      getTrigger()?.focus();
    }
  }, [cmid]);
  useEffect(() => {
    if (!open) {
      return void 0;
    }
    const selectedindex = options.findIndex((option) => option.value === current);
    if (selectedindex <= 0) {
      return void 0;
    }
    let frame = requestAnimationFrame(() => {
      frame = requestAnimationFrame(() => itemRefs.current[selectedindex]?.focus());
    });
    return () => cancelAnimationFrame(frame);
  }, [open, options, current]);
  const closeMenu = /* @__PURE__ */ __name(() => {
    setOpen(false);
    getTrigger()?.focus();
  }, "closeMenu");
  const handleKeyDown = /* @__PURE__ */ __name((event) => {
    if (event.key === "Tab") {
      event.preventDefault();
      closeMenu();
      return;
    }
    const items = itemRefs.current.filter((item) => item !== null);
    const index = items.indexOf(document.activeElement);
    let wrapto = null;
    if (event.key === "ArrowDown" && index === items.length - 1) {
      wrapto = items[0];
    } else if (event.key === "ArrowUp" && index === 0) {
      wrapto = items[items.length - 1];
    }
    if (wrapto) {
      event.preventDefault();
      event.stopPropagation();
      wrapto.focus();
    }
  }, "handleKeyDown");
  const selected = options.find((option) => option.value === current) ?? options[0];
  const selectOption = /* @__PURE__ */ __name((option) => {
    closeMenu();
    if (option.value === current) {
      return;
    }
    const previous = current;
    setCurrent(option.value);
    pendingFocus.add(cmid);
    const pending = new Pending("core_course/local/cm/GroupModeDropdown:select");
    requireAsync("core_courseformat/courseeditor").then(({ getCurrentCourseEditor }) => getCurrentCourseEditor().dispatch(option.mutation, [cmid])).catch(() => {
      pendingFocus.delete(cmid);
      setCurrent(previous);
    }).finally(() => pending.resolve());
  }, "selectOption");
  return /* @__PURE__ */ jsxDEV(
    Dropdown,
    {
      ref: dropdownRef,
      open,
      onOpenChange: setOpen,
      placement: "bottom-end",
      trigger: /* @__PURE__ */ jsxDEV(
        DropdownTrigger,
        {
          className: "groupmode-trigger",
          label: selected.triggerlabel,
          appearance: "default",
          size: "md",
          open,
          "aria-label": selected.accessiblename,
          startIcon: /* @__PURE__ */ jsxDEV(
            "i",
            {
              className: "groupmode-icon",
              "aria-hidden": "true",
              dangerouslySetInnerHTML: { __html: selected.icon }
            },
            void 0,
            false,
            {
              fileName: "public/course/js/esm/src/local/cm/GroupModeDropdown.tsx",
              lineNumber: 160,
              columnNumber: 25
            },
            this
          )
        },
        void 0,
        false,
        {
          fileName: "public/course/js/esm/src/local/cm/GroupModeDropdown.tsx",
          lineNumber: 152,
          columnNumber: 17
        },
        this
      ),
      children: /* @__PURE__ */ jsxDEV("div", { role: "none", className: "groupmode-menu", onKeyDown: handleKeyDown, children: options.map((option, index) => /* @__PURE__ */ jsxDEV(
        DropdownItemSelect,
        {
          ref: (element) => {
            itemRefs.current[index] = element;
          },
          className: "groupmode-option",
          label: option.label,
          description: option.description,
          selected: option.value === current,
          startIcon: /* @__PURE__ */ jsxDEV(
            "i",
            {
              className: "groupmode-icon",
              "aria-hidden": "true",
              dangerouslySetInnerHTML: { __html: option.icon }
            },
            void 0,
            false,
            {
              fileName: "public/course/js/esm/src/local/cm/GroupModeDropdown.tsx",
              lineNumber: 181,
              columnNumber: 29
            },
            this
          ),
          onClick: () => selectOption(option)
        },
        option.value,
        false,
        {
          fileName: "public/course/js/esm/src/local/cm/GroupModeDropdown.tsx",
          lineNumber: 171,
          columnNumber: 21
        },
        this
      )) }, void 0, false, {
        fileName: "public/course/js/esm/src/local/cm/GroupModeDropdown.tsx",
        lineNumber: 169,
        columnNumber: 13
      }, this)
    },
    void 0,
    false,
    {
      fileName: "public/course/js/esm/src/local/cm/GroupModeDropdown.tsx",
      lineNumber: 146,
      columnNumber: 9
    },
    this
  );
}
__name(GroupModeDropdown, "GroupModeDropdown");
export {
  GroupModeDropdown as default
};
//# sourceMappingURL=GroupModeDropdown.dev.js.map

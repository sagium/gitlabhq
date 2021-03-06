import Vue from 'vue';
import { parseBoolean } from '~/lib/utils/common_utils';
import ActiveToggle from './components/active_toggle.vue';

export default el => {
  if (!el) {
    return null;
  }

  const { showActive: showActiveStr, activated: activatedStr } = el.dataset;
  const showActive = parseBoolean(showActiveStr);
  const activated = parseBoolean(activatedStr);

  if (!showActive) {
    return null;
  }

  return new Vue({
    el,
    render(createElement) {
      return createElement(ActiveToggle, {
        props: {
          initialActivated: activated,
        },
      });
    },
  });
};

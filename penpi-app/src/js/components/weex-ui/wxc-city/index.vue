<!-- CopyRight (C) 2017-2022 Alibaba Group Holding Limited. -->
<!-- Created by Tw93 on 17/12/27. -->
<!--A City -->

<template>
  <div class="wxc-city" ref="city">
    <pp-status-bar></pp-status-bar>
    <wxc-searchbar ref="wxc-searchbar"
                   v-bind="mergeInputConfig"
                   @wxcSearchbarInputOnInput="onInput"
                   @wxcSearchbarInputReturned="onSubmit"
                   @wxcSearchbarCancelClicked="onCancel"></wxc-searchbar>

    <wxc-tab ref="wxc-tab"
             v-if="showTab"
             @wxcTabSwitch="onTabSwitch"></wxc-tab>

    <wxc-indexlist :normal-list="normalList"
                   :hot-list-config="hotListConfig"
                   :nav-style="{ top: '24px'}"
                   :height="listHeight"
                   :show-index="showIndex"
                   :only-show-list="onlyShowList"
                   :city-location-config="cityLocationConfig"
                   @wxcIndexlistItemClicked="onItemClick"></wxc-indexlist>

    <wxc-result type="noGoods"
                :wrap-style="{top:'84px'}"
                :show="true"
                :customSet="result"
                v-if="showError"></wxc-result>
  </div>
</template>

<script>
  const animation = weex.requireModule('animation');

  import {Utils, WxcSearchbar, WxcResult, WxcIndexlist} from 'weex-ui';
  import wxcTab from './tab.vue';
  import PpStatusBar from '../../penpi-ui/pp-status-bar/index'

  export default {
    components: { wxcTab, WxcSearchbar, WxcResult, WxcIndexlist, PpStatusBar },
    props: {
      inputConfig: {
        type: Object,
        default: () => ({})
      },
      normalList: {
        type: Array,
        default: () => ([])
      },
      cityHeight: {
        type: Number,
        default: 0
      },
      showTab: {
        type: Boolean,
        default: false
      },
      hotListConfig: {
        type: Object,
        default: () => ({})
      },
      cityLocationConfig: {
        type: Object,
        default: () => ({})
      },
      onlyShowList: {
        type: Boolean,
        default: false
      },
      showIndex: {
        type: Boolean,
        default: true
      }
    },
    data: () => ({
      tId: null,
      result: {
        noGoods: {
          pic: 'https://img.alicdn.com/tfs/TB1SpPHkf2H8KJjy0FcXXaDlFXa-200-200.png',
          button: '',
          content: '搜索无结果'
        }
      }
    }),
    computed: {
      showError () {
        const { normalList, hotListConfig } = this;
        return (normalList && normalList.length < 1) && (hotListConfig && hotListConfig.list && hotListConfig.list.length < 1)
      },
      listHeight () {
        // 兼容去头逻辑
        // let pageHeight = Utils.env.getPageHeight();
        let pageHeight = weex.config.eros.realDeviceHeight;
        const { cityHeight } = this;
        if (cityHeight && !isNaN(cityHeight) && cityHeight > 0) {
          pageHeight = cityHeight;
        }

        // searchInput 84
        const tabHeight = this.showTab ? 90 : 0;
        return pageHeight - 84 - tabHeight - (weex.config.eros.statusBarHeight ? weex.config.eros.statusBarHeight : 40);
      },
      mergeInputConfig () {
        return {
          autofocus: false,
          alwaysShowCancel: true,
          placeholder: '中文/拼音/首字母',
          ...this.inputConfig
        }
      }
    },
    methods: {
      onTabSwitch (e) {
        this.$emit('wxcTabSwitch', e);
      },
      switchTab (i = 0) {
        setTimeout(() => {
          this.$refs['wxc-tab'].switchTab(i)
        }, 100);
      },
      onItemClick (e) {
        this.$refs['wxc-searchbar'].autoBlur();
        this.show(false);
        this.$emit('wxcCityItemSelected', { item: e.item });
      },
      onInput (e) {
        clearTimeout(this.tId);
        this.tId = setTimeout(() => {
          this.$emit('wxcCityOnInput', {
            value: e.value
          });
        }, 300);
      },
      onCancel () {
        this.autoBlur();
        this.show(false);
        this.$emit('wxcCityCanceled', {});
      },
      onSubmit (e) {
        this.autoBlur();
        this.$emit('wxcCityOnKeyUpEnter', { value: e.value });
      },
      autoBlur () {
        const inputRef = this.$refs['wxc-searchbar'];
        inputRef && inputRef.autoBlur();
      },
      show (status = true, callback = null) {
        animation.transition(this.$refs.city, {
          styles: {
            transform: `translateX(${status ? -750 : 750}px)`
          },
          duration: status ? 250 : 300, // ms
          timingFunction: status ? 'ease-in' : 'ease-out',
          delay: 0 // ms
        }, function () {
          callback && callback();
        });
      }
    }
  };
</script>

<style scoped>
  .wxc-city {
    position: fixed;
    width: 750px;
    top: 0;
    left: 750px;
    right: 0;
    bottom: 0;
    background-color: #F2F3F4;
  }
</style>

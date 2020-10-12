new Vue({
  el: '#dashboard_items',
  data: {
    visibleModal: true
  },
  computed: {
  },
  methods: {
    loadFromSupplier() {
      this.visibleModal = false;
    },
    hideModal() {
      this.visibleModal = false;
    }
  }
})

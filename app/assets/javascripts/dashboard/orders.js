new Vue({
  el: '#dashboard_orders',
  data: {
    orders: gon.orders,
    page: 1,
    pagenationButtonNum: 5,
    limit: 15
  },
  computed: {
    pageOrders() {
      return this.orders.slice(this.limit * (this.page - 1), this.limit * this.page);
    },
    pageTotalNum() {
      return Math.ceil(this.orders.length / this.limit);
    },
    pagenationButtonHalfNum() {
      return Math.ceil(this.pagenationButtonNum / 2);
    },
    startIndex() {
      return (this.page - 1) * this.limit + 1;
    },
    endIndex() {
      return this.page == this.pageTotalNum ? this.orders.length : this.page * this.limit;
    }
  },
  methods: {
    visiblePagenationButton(p) {
      let n = this.pagenationButtonHalfNum;
      return Math.abs(this.page - p) < n
        || (this.page < n && p <= this.pagenationButtonNum)
        || (this.page > this.pageTotalNum - n && p >= this.pageTotalNum - this.pagenationButtonNum + 1);
    }
  }
})

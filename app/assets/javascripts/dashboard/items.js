new Vue({
  el: '#dashboard_items',
  data: {
    uploadFile: null,
    items: gon.items,
    page: 1,
    pagenationButtonNum: 5
  },
  computed: {
    pageItems() {
      return this.items.slice(10 * (this.page - 1), 10 * this.page);
    },
    pageTotalNum() {
      return Math.ceil(this.items.length / 10);
    },
    pagenationButtonHalfNum() {
      return Math.ceil(this.pagenationButtonNum / 2);
    }
  },
  methods: {
    changedFile(e) {
      e.preventDefault();
      this.uploadFile = e.target.files[0];
    },
    visiblePagenationButton(p) {
      let n = this.pagenationButtonHalfNum;
      return Math.abs(this.page - p) < n
        || (this.page < n && p <= this.pagenationButtonNum)
        || (this.page > this.pageTotalNum - n && p >= this.pageTotalNum - this.pagenationButtonNum + 1);
    }
  }
})

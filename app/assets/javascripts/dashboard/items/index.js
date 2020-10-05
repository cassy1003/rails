new Vue({
  el: '#dashboard_items',
  data: {
    uploadFile: null,
    items: gon.items,
    page: 1,
    pagenationButtonNum: 5,
    limit: 10
  },
  computed: {
    pageItems() {
      return this.items.slice(this.limit * (this.page - 1), this.limit * this.page);
    },
    pageTotalNum() {
      return Math.ceil(this.items.length / this.limit);
    },
    pagenationButtonHalfNum() {
      return Math.ceil(this.pagenationButtonNum / 2);
    },
    startIndex() {
      return (this.page - 1) * this.limit + 1;
    },
    endIndex() {
      return this.page == this.pageTotalNum ? this.items.length : this.page * this.limit;
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

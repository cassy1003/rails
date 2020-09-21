new Vue({
  el: '#dashboard_members',
  data: {
    members: gon.members,
    page: 1,
    pagenationButtonNum: 5,
    limit: 10
  },
  computed: {
    pageMembers() {
      return this.members.slice(this.limit * (this.page - 1), this.limit * this.page);
    },
    pageTotalNum() {
      return Math.ceil(this.members.length / this.limit);
    },
    pagenationButtonHalfNum() {
      return Math.ceil(this.pagenationButtonNum / 2);
    },
    startIndex() {
      return (this.page - 1) * this.limit + 1;
    },
    endIndex() {
      return this.page == this.pageTotalNum ? this.members.length : this.page * this.limit;
    }
  },
  methods: {
    approve(member) {
      axios.put('/api/members/' + member.id, {
        status: 'approved'
      }, {
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': window.token
        }
      }).then(res => {
        console.log(res);
        member.isApproved = res['data']['isApproved'];
        member.status = res['data']['status'];
      })
    },
    visiblePagenationButton(p) {
      let n = this.pagenationButtonHalfNum;
      return Math.abs(this.page - p) < n
        || (this.page < n && p <= this.pagenationButtonNum)
        || (this.page > this.pageTotalNum - n && p >= this.pageTotalNum - this.pagenationButtonNum + 1);
    }
  }
})

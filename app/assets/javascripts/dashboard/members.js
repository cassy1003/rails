const app = new Vue({
  el: '#dashboard_members',
  data: {
    test: 'hoge'
  },
  methods: {
    approve(id) {
      axios.put('/api/members/' + id, {
        status: 'approve'
      }).then(res => {
        console.log(res);
      })
    },
    stop(id) {
    },
  }
})

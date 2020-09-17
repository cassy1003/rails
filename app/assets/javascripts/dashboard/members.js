const app = new Vue({
  el: '#dashboard_members',
  data: {
  },
  methods: {
    approve(id) {
      axios.put('/api/members/' + id, {
        status: 'approved'
      }, {
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': window.token
        }
      }).then(res => {
        location.reload();
      })
    },
  }
})

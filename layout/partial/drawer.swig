<app-drawer>
  <paper-drawer-title photo="{{ gravatar(config.email) }}" name="{{ config.author }}" email="{{ config.email }}"></paper-drawer-title>
  <paper-drawer-subheader>Categories</paper-drawer-subheader>
  {{ list_categories_drawer({show_count: false}) }}
</app-drawer>

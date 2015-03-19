import Ember from 'ember';

export default Ember.Mixin.create({

  needs: ['deployment', 'configure-organization', 'configure-environment'],

  hasName: function() {
    return (this.get('name.length') > 0);
  }.property('name'),
  hasNoName: Ember.computed.not('hasName'),

  hasOrganization: function() {
    return !!(this.get('organization'));
  }.property('organization'),
  hasNoOrganization: Ember.computed.not('hasOrganization'),

  hasLifecycleEnvironment: function() {
    return !!(this.get('lifecycle_environment'));
  }.property('lifecycle_environment'),
  hasNoLifecycleEnvironment: Ember.computed.not('hasLifecycleEnvironment'),

  // disable All if there is no deployment name
  disableAll: Ember.computed.alias("hasNoName"),

  // disable Next on Deployment Name if there is no deployment name
  disableNextOnDeploymentName: Ember.computed.alias("hasNoName"),

  // disable Next on Configure Organization if no organization is selected
  disableNextOnConfigureOrganization: Ember.computed.or('hasNoOrganization', 'disableAll'),

  // disable Next on Lifecycle Environment if no lifecycle environment is selected
  disableNextOnLifecycleEnvironment: Ember.computed.or('hasNoLifecycleEnvironment', 'disableAll'),

  // Satellite Tabs Only
  disableTabDeploymentName: false, // always enable tab for entering deployment name
  disableTabConfigureOrganization: Ember.computed.alias('disableNextOnDeploymentName'),
  disableTabLifecycleEnvironment: Ember.computed.alias("disableNextOnConfigureOrganization"),

});
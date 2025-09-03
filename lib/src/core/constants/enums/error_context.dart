enum ErrorContext {
  appStartup,

  // Auth contexts
  login,
  register,
  logout,
  forgotPassword,
  verifyEmail,
  googleSignIn,
  appleSignIn,
  linkProvider,
  reauthenticate,
  updateEmail,
  updatePassword,
  deleteAccount,
  sendEmailVerification,

  // Todo contexts
  fetchingTodos,
  creatingTodo,
  updatingTodo,
  deletingTodo,

  // Paywall contexts
  inAppPurchase,
  localStorage,

  // Review contexts
  reviewSystem,
  
  // Data contexts
  dataLoading,
  dataSaving,
  dataDeletion,
  
  // Business logic contexts
  businessLogic,
  userAction,
  initialization,

  // Generic contexts
  unknown,
}

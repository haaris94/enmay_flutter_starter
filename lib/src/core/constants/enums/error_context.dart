enum ErrorContext {
  // Auth contexts
  login,
  register,
  logout,
  forgotPassword,
  verifyEmail,

  // Todo contexts
  fetchingTodos,
  creatingTodo,
  updatingTodo,
  deletingTodo,

  // Generic contexts
  unknown,
}

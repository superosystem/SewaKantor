import { configureStore } from "@reduxjs/toolkit";
import rootReducers from "./Feature";

export const store = configureStore({
  reducer: rootReducers,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: false,
    }),
});

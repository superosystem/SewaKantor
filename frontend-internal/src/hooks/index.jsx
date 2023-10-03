import { createSlice } from "@reduxjs/toolkit";

export const contohSlice = createSlice({
  name: "contoh",
  initialState: {
    contoh: [],
  },
  reducers: {
    setContoh: (state, action) => {
      state.contoh = action.payload;
    },
  },
});

export const { setContoh } = contohSlice.actions;

export default contohSlice.reducer;

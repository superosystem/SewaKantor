import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import APIReview from "apis/restApis/Review";

const initialState = {
  data: [],
  loading: false,
};

export const fetchReview = createAsyncThunk("fetch/review", async () => {
  try {
    const res = await APIReview.getAllReview();
    return res.data.data;
  } catch (err) {
    console.log(err);
  }
});

export const updateReview = createAsyncThunk(
  "updateReview/review",
  async (data) => {
    try {
      const res = await APIReview.updateReview(data);
      return res.data;
    } catch (err) {
      console.log(err);
    }
  }
);

export const deleteReview = createAsyncThunk("delete/review", async (id) => {
  try {
    const res = await APIReview.deleteReview(id);
    return res;
  } catch (err) {
    console.log(err);
  }
});

const reviewSlice = createSlice({
  name: "reviews",
  initialState,
  extraReducers(builder) {
    builder
      .addCase(fetchReview.pending, (state, action) => {
        state.status = "loading";
      })
      .addCase(fetchReview.fulfilled, (state, action) => {
        state.status = "succeeded";
        state.data = action.payload;
      })
      .addCase(fetchReview.rejected, (state, action) => {
        state.status = "failed";
      })
      .addCase(updateReview.pending, (state, action) => {
        state.status = "loading";
      })
      .addCase(updateReview.fulfilled, (state, action) => {
        state.data = state.data.map((val) => {
          if (val.id === action.payload.id) {
            return action.payload;
          }
          return val;
        });
        state.loading = false;
      })
      .addCase(updateReview.rejected, (state, action) => {
        state.status = "failed";
      });
  },
});

export default reviewSlice.reducer;

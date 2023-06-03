import React from 'react'
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import Dashboard from '../pages/Dashboard';
import ManageBooking from '../pages/booking/ManageBooking';

import VaccineStock from '../pages/vaccine/VaccineStock';
import VaccineBrand from '../pages/vaccine/VaccineBrand';
import LoginPage from '../pages/auth/Login';
import Landing from '../pages/Landing';
import PrivateRoute from './PrivateRoute';
import ProtectedRoute from './ProtectedRoute';
import ManageSession from '../pages/sessions/ManageSession';
import SessionDetail from '../pages/sessions/SessionDetail';
import BookDetail from '../pages/booking/BookDetail';
import NotFound from '../pages/NotFound';

const SetupRouter = () => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path='/' element={<PrivateRoute />}>
          <Route path='/dashboard' element={<Dashboard />}/>
          <Route path='/manage-booking' element={<ManageBooking />}/>
          <Route path='/manage-booking/:id' element={<BookDetail />}/>
          <Route path='/manage-session' element={<ManageSession />}/>
          <Route path='/manage-session/:id' element={<SessionDetail />}/>
          <Route path='/vaccine-stock' element={<VaccineStock />}/>
          <Route path='/vaccine-brand' element={<VaccineBrand />}/>
        </Route>
        <Route path='/' element={<ProtectedRoute />}>
          <Route index element={<Landing/>}/>
          <Route path='/login' element={<LoginPage/>}/>
        </Route>
        <Route path='*' element={<NotFound/>}/>
      </Routes>
    </BrowserRouter>
  )
}

export default SetupRouter;
import { LayoutAdmin } from "components";
import { Navigate, Outlet } from "react-router-dom";
import Auth from "utils/auth";

export default function PrivateRoute() {
  if (!Auth.isAuthorization()) {
    return <Navigate to="/login" replace />;
  }
  return (
    <LayoutAdmin>
      <Outlet />
    </LayoutAdmin>
  );
}
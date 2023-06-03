import React from "react";
import { Box, Container, Stack, Typography } from "@mui/material";
import useCurrentScreen from "../hooks/useCurrentScreen";
import theme from "../themes";
import Nurse from "../assets/img/nurse.png";

const Banner = () => {
  const { mobile } = useCurrentScreen();
  return (
    <Box
      disableGutters
      sx={{
        height: "max-content",
        width: "100%",
        background: theme.color.greenOpaque,
        my: 6,
        py: 4,
        mt: mobile ? 20 : 6,
      }}
    >
      <Container
        sx={{
          display: "flex",
          flexDirection: mobile ? "column" : "row",
          justifyContent: "space-between",
          alignItems: "center",
          gap: 8,
        }}
      >
        <img src={Nurse} alt="nurse-img" width={420} />
        <Stack spacing={2}>
          <Typography variant="h3" gutterBottom>
            Easily and quickly get the vaccine with Vaccine Partners
          </Typography>
          <Typography variant="p">
            Vaccine Partners is an application developed to assist government
            programs in taking preventive actions to stop the spread of
            Coronavirus Disease (COVID-19).
          </Typography>
          <Typography variant="p">
            In an effort to provide the best service, we have collaborated with
            health facilities spread throughout Indonesia so that even
            distribution of vaccinations can more easily reach all Indonesian
            citizens.
          </Typography>
          <Typography variant="p">
            Don't hesitate to immediately plan your preferred vaccination in
            just a few clicks via the Vaccine Partners App!
          </Typography>
        </Stack>
      </Container>
    </Box>
  );
};

export default Banner;

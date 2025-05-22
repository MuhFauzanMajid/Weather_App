const express = require("express");
const axios = require("axios");

// Load .env in local dev (optional)
require("dotenv").config();

const app = express();

// Firebase v2 functions & secret handling
const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");

const OPENWEATHER_API_KEY = defineSecret("OPENWEATHER_API_KEY");

app.get("/getWeather", async (req, res) => {
  const city = req.query.city;

  if (!city) {
    return res.status(400).send({ error: "City name is required" });
  }

  try {
    const response = await axios.get("https://api.openweathermap.org/data/2.5/weather", {
      params: {
        q: city,
        appid: OPENWEATHER_API_KEY.value(), // ✅ Use secret value
        units: "metric",
      },
    });

    res.status(200).send(response.data);
  } catch (error) {
    res.status(500).send({
      error: "Failed to fetch weather data",
      details: error.response?.data || error.message,
    });
  }
});

// Export function (2nd Gen only)
exports.getWeather = onRequest(
  {
    region: "us-central1",
    memory: "256MiB",
    timeoutSeconds: 30,
    secrets: [OPENWEATHER_API_KEY], // ✅ Register secret
  },
  app
);

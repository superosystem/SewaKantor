package com.gusrylmubarok.cuacapp.ui.weather

import com.gusrylmubarok.cuacapp.domain.weather.WeatherInfo

data class WeatherState(
    val weatherInfo: WeatherInfo? = null,
    val isLoading: Boolean = false,
    val error: String? = null
)
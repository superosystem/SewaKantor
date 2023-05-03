package com.gusrylmubarok.cuacapp.domain.repository

import com.gusrylmubarok.cuacapp.common.Resource
import com.gusrylmubarok.cuacapp.domain.weather.WeatherInfo

interface WeatherRepository {
    suspend fun getWeatherData(lat: Double, long: Double): Resource<WeatherInfo>
}
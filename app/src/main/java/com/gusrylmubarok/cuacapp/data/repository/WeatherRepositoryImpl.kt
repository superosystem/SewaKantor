package com.gusrylmubarok.cuacapp.data.repository

import com.gusrylmubarok.cuacapp.common.Resource
import com.gusrylmubarok.cuacapp.data.mapper.toWeatherInfo
import com.gusrylmubarok.cuacapp.data.remote.WeatherApi
import com.gusrylmubarok.cuacapp.domain.repository.WeatherRepository
import com.gusrylmubarok.cuacapp.domain.weather.WeatherInfo
import javax.inject.Inject

class WeatherRepositoryImpl @Inject constructor(
    private val api: WeatherApi
) : WeatherRepository {
    override suspend fun getWeatherData(lat: Double, long: Double): Resource<WeatherInfo> {
        return try {
            Resource.Success(
                data = api.getWeatherData(
                    latitude = lat,
                    longitude = long
                ).toWeatherInfo()
            )
        } catch (e: Exception) {
            Resource.Error(e.message ?: "an unknown error occurred")
        }
    }
}
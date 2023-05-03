package com.gusrylmubarok.cuacapp.di

import com.gusrylmubarok.cuacapp.data.location.DefaultLocationTracker
import com.gusrylmubarok.cuacapp.domain.location.LocationTracker
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class LocationModule {
    @Binds
    @Singleton
    abstract fun bindLocationTracker(
        defaultLocationTracker: DefaultLocationTracker
    ): LocationTracker
}
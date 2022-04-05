/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import android.location.Location;

import io.reactivex.disposables.CompositeDisposable;
import is.stokkur.afladagbok.android.base.BaseViewModel;
import is.stokkur.afladagbok.android.db.entity.TripLocation;
import is.stokkur.afladagbok.android.utils.NavigationController.State;
import is.stokkur.afladagbok.android.utils.Persistence;

/**
 * Created by annalaufey on 11/7/17.
 */

public class MainViewModel extends BaseViewModel {

    private final SingleLiveEvent<State> state = new SingleLiveEvent<>();
    private final MutableLiveData<Location> locationMutableLiveData = new MutableLiveData<>();
    private final DataRepository mRepository;
    private CompositeDisposable compositeDisposable;

    public MainViewModel() {
        this.compositeDisposable = new CompositeDisposable();
        this.mRepository = AfladagbokApplication.getInstance().getRepository();
    }


    public LiveData<State> getState() {
        return state;
    }

    public void changeState(State state) {
        if (this.state.getValue() == state) {
            return;
        }
        this.state.setValue(state);
    }

    public LiveData<Location> getLocation() {
        return locationMutableLiveData;
    }

    public void setLocationMutableLiveData(Location location) {
        locationMutableLiveData.setValue(location);
        if (location != null && Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            mRepository.saveTripRouteLocation(
                    new TripLocation(location.getLatitude(), location.getLongitude()));
        }
    }

}

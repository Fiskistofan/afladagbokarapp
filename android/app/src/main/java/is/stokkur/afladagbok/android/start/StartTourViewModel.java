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

package is.stokkur.afladagbok.android.start;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.fragment.app.Fragment;

import com.google.gson.Gson;

import java.util.ArrayList;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.DataRepository;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.base.BaseViewModel;
import is.stokkur.afladagbok.android.db.entity.StoredToss;
import is.stokkur.afladagbok.android.models.Equipment;
import is.stokkur.afladagbok.android.models.FishingEquipments;
import is.stokkur.afladagbok.android.models.Port;
import is.stokkur.afladagbok.android.models.ProfileResponse;
import is.stokkur.afladagbok.android.models.StartTourBody;
import is.stokkur.afladagbok.android.models.StartTourResponse;
import is.stokkur.afladagbok.android.models.Toss;
import is.stokkur.afladagbok.android.start.harbor.SelectHarborFragment;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;

/**
 * Created by annalaufey on 1/26/18.
 */

public class StartTourViewModel extends BaseViewModel {

    final private MutableLiveData<StartTourResponse> startTourResponseMutableLiveData =
            new MutableLiveData<>();
    final private DataRepository mRepository;
    public Fragment mView = null;
    private CompositeDisposable compositeDisposable;
    private Equipment startTourEquipment;

    public StartTourViewModel() {
        this.compositeDisposable = new CompositeDisposable();
        this.mRepository = AfladagbokApplication.getInstance().getRepository();
        initStartTourEquipment();
    }

    public void startTour(StartTourBody body) {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .startTour(body)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    private void onSuccess(StartTourResponse startTourResponse) {
        if (startTourResponse == null || startTourResponse.getTour() == null) {
            ((SelectHarborFragment) mView).displayError(AfladagbokApplication.getAppContext().getResources().getString(R.string.general_error), true);
            ((SelectHarborFragment) mView).hideProgressBar();
            return;
        }
        Persistence.saveBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP, true);
        Gson gson = new Gson();
        String json = gson.toJson(startTourResponse);
        Persistence.saveStringValue(Persistence.KEY_CURRENT_ACTIVE_TRIP, json);

        for (Toss toss : startTourResponse.getTosses()) {
            StoredToss storedToss = new StoredToss(toss.getTourId(), toss.getId(),
                    toss.getDatetime(), toss.getLatitude(), toss.getLongitude(), toss.getCount(),
                    toss.getPulledCount(), toss.getEquipmentTypeId());
            storedToss.setSent(true);
            mRepository.saveStoredToss(storedToss);
        }
        startTourResponseMutableLiveData.setValue(startTourResponse);
    }

    public ArrayList<Port> getPorts() {
        ProfileResponse profile = GsonInstance.sInstance.
                fromJson(Persistence.getStringValue(Persistence.KEY_PROFILE), ProfileResponse.class);
        return profile.getPorts();
    }

    public int preferredEquipmentId() {
        ProfileResponse profile = GsonInstance.sInstance.
                fromJson(Persistence.getStringValue(Persistence.KEY_PROFILE), ProfileResponse.class);
        return profile.getEquipment().get(0).getFishingEquipmentTypeId();
    }

    public ArrayList<FishingEquipments> getFishingEquipmentTypes() {
        ArrayList<FishingEquipments> filteredEquipments = new ArrayList<>();

        ProfileResponse profile = GsonInstance.sInstance.
                fromJson(Persistence.getStringValue(Persistence.KEY_PROFILE), ProfileResponse.class);
        int equipmentId = profile.getEquipment().get(0).getFishingEquipmentTypeId();

        ArrayList<FishingEquipments> fishingEquipments = profile.getFishingEquipments();
        int size = fishingEquipments.size();
        FishingEquipments fishingEquipment;
        FishingEquipments preferredEquipment = fishingEquipments.get(0);
        for (int i = 0; i < size; ++i) {
            fishingEquipment = fishingEquipments.get(i);
            if (fishingEquipment.getId() != equipmentId) {
                filteredEquipments.add(fishingEquipment);
            } else {
                preferredEquipment = fishingEquipment;
            }
        }

        filteredEquipments.add(0, preferredEquipment);
        return filteredEquipments;
    }

    public LiveData<StartTourResponse> getTourResponse() {
        return startTourResponseMutableLiveData;
    }

    public void initStartTourEquipment() {
        ProfileResponse profile = GsonInstance.sInstance.
                fromJson(Persistence.getStringValue(Persistence.KEY_PROFILE), ProfileResponse.class);
        startTourEquipment = profile.getEquipment().get(0);
    }

    public Equipment getStartTourEquipment() {
        return startTourEquipment;
    }

}

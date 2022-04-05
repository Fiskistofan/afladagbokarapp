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

package is.stokkur.afladagbok.android.login.phone;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import is.stokkur.afladagbok.android.api.Client;
import is.stokkur.afladagbok.android.base.BaseViewModel;
import is.stokkur.afladagbok.android.models.ProfileResponse;

import static is.stokkur.afladagbok.android.login.LoginUtils.validLogin;

/**
 * Created by annalaufey on 1/12/18.
 */

public class PhoneViewModel extends BaseViewModel {

    public PhoneFragment mView = null;
    private CompositeDisposable compositeDisposable;

    public PhoneViewModel() {
        this.compositeDisposable = new CompositeDisposable();
    }

    public void getUserProfile() {
        compositeDisposable.add(Client.sharedClient().getClientInterface()
                .getUserInfo()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onSuccess, this::onError));
    }

    private void onSuccess(ProfileResponse response) {
        int reasonId = validLogin(response);
        if (reasonId == 0) {
            if (mView != null) {
                mView.goToMainView();
            }
        } else {
            mView.hideProgressBar();
            mView.displayError(AfladagbokApplication.getAppContext().
                    getString(reasonId), true);
        }
    }

}

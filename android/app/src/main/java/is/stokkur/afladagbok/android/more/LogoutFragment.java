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

package is.stokkur.afladagbok.android.more;

import android.app.AlertDialog;
import androidx.lifecycle.ViewModelProviders;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.login.LoginActivity;
import is.stokkur.afladagbok.android.models.ProfileResponse;
import is.stokkur.afladagbok.android.utils.GsonInstance;
import is.stokkur.afladagbok.android.utils.Persistence;

/**
 * Created by annalaufey on 11/22/17.
 */

public class LogoutFragment extends BaseFragment {

    @BindView(R.id.profile_name)
    TextView profileName;
    @BindView(R.id.profile_kennitala)
    TextView profileKennitala;
    MoreViewModel viewModel;

    public static LogoutFragment newInstance() {
        LogoutFragment fragment = new LogoutFragment();
        return fragment;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.logout_fragment, container, false);
        ButterKnife.bind(this, view);
        viewModel = ViewModelProviders.of(this).get(MoreViewModel.class);
        viewModel.mView = this;
        return view;
    }

    @OnClick(R.id.logout_button)
    public void onLogoutButtonClicked() {
        if (Persistence.getBooleanValue(Persistence.KEY_IS_ACTIVE_TRIP)) {
            displayError(getString(R.string.finish_tour_before_logout_error), true);
            return;
        }
        new AlertDialog.Builder(getActivity()).
                setTitle(R.string.confirm_logout_title).
                setMessage(R.string.confirm_logout_message).
                setPositiveButton(R.string.confirm_logout, (dialog, which) -> {
                    dialog.dismiss();
                    viewModel.deleteAllData();
                    Intent intent = new Intent(getActivity(), LoginActivity.class);
                    startActivity(intent);
                    getActivity().finish();
                }).
                setNegativeButton(R.string.cancel, (dialog, which) -> dialog.dismiss()).
                create().
                show();
    }

    private void setProfile() {
        ProfileResponse profile = GsonInstance.sInstance.fromJson(Persistence.getStringValue(Persistence.KEY_PROFILE), ProfileResponse.class);
        if (profile != null) {
            profileName.setText(profile.getProfile().getName());
            profileKennitala.setText(getResources().getString(R.string.kennitala, profile.getProfile().getSsn()));
        }
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        setProfile();
    }

}

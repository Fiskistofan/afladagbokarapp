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

package is.stokkur.afladagbok.android.book;

import androidx.lifecycle.ViewModelProviders;
import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.LocationUpdateListener;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseActivity;
import is.stokkur.afladagbok.android.utils.Keys;

/**
 * Created by annalaufey on 11/14/17.
 */

public class BookCatchActivity extends BaseActivity implements LocationUpdateListener {

    @BindView(R.id.back_button)
    LinearLayout backButton;
    @BindView(R.id.back_button_text)
    TextView backButtonText;
    @BindView(R.id.header_title)
    TextView headerTitle;
    BookViewModel viewModel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_book_catch);
        ButterKnife.bind(this);
        setupViewModel();
        setLocationListener(this, BookCatchActivity.class.getSimpleName());
        Intent intent = getIntent();
        if (intent.hasExtra(Keys.CHANGE_REGISTRY) &&
                intent.getBooleanExtra(Keys.CHANGE_REGISTRY, false) &&
                intent.hasExtra(Keys.SELECTED_CHANGE_CATCH)) {
            viewModel.setEditCatchId(intent.getStringExtra(Keys.SELECTED_CHANGE_CATCH));
            openFragmentWithAnimation(new EditCatchFragment());
        } else {
            openFragmentWithAnimation(new BookPullsFragment());
        }
        backButton.setVisibility(View.VISIBLE);
    }

    /**
     * Gets the MainViewModel and register observer(s)
     */
    private void setupViewModel() {
        viewModel = ViewModelProviders.of(this).get(BookViewModel.class);
        viewModel.getLocation().observe(this, this::setLastKnownLocation);
    }

    @OnClick(R.id.back_button)
    public void OnBackButtonClick() {
        Fragment fragment = getSupportFragmentManager().findFragmentById(R.id.container);
        if (fragment instanceof ChooseDetailSpeciesFragment) {
            finish();
        } else {
            onBackPressed();
        }
    }

    public void setLayoutHeader(String backButton, String title) {
        backButtonText.setText(backButton);
        headerTitle.setText(title);
    }

    @Override
    public void onLocationUpdated(Location location) {
        viewModel.setLocationMutableLiveData(location);
    }

}

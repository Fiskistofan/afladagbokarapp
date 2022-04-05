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

package is.stokkur.afladagbok.android.finish;

import android.app.Dialog;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.dialogs.StopTourListener;
import is.stokkur.afladagbok.android.models.MammalAndBirdsTotalCatch;
import is.stokkur.afladagbok.android.models.StatisticsDetailResponse;
import is.stokkur.afladagbok.android.models.TourCatchDetailDto;
import is.stokkur.afladagbok.android.statistics.StatisticHelper;

public class FinishTourDialog extends Dialog {
    @BindView(R.id.statistics_layout)
    LinearLayout statisticsLayout;
    @BindView(R.id.statistics_list_layout)
    LinearLayout statisticsList;
    @BindView(R.id.date_of_trip_txt)
    TextView dateOfTripTxt;
    @BindView(R.id.total_catch_txt)
    TextView totalCatchtxt;
    @BindView(R.id.harbor_txt)
    TextView harborTxt;
    @BindView(R.id.total_mammal_catch_txt)
    TextView totalMammalCatchTxt;
    @BindView(R.id.total_species_txt)
    TextView totalSpeciesTxt;
    @BindView(R.id.total_registrations_txt)
    TextView totalRegistrationTxt;
    @BindView(R.id.statistics_detail_layout)
    LinearLayout statisticsDetailLayout;
    @BindView(R.id.btn_cancel)
    Button cancel_btn;
    @BindView(R.id.btn_finish)
    Button finish_btn;

    private StopTourListener stopTourListener;
    private StatisticsDetailResponse statisticResponse;
    private Fragment frag;



    public <T extends Fragment & StopTourListener> FinishTourDialog(@NonNull T fragment, @NonNull StatisticsDetailResponse statisticResponse) {
        super(fragment.getContext());

        this.stopTourListener = fragment;
        this.statisticResponse = statisticResponse;
        this.frag = fragment;

        Window window = getWindow();
        setContentView(R.layout.finish_tour_dialog);

        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(0));
            window.setLayout(ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT);
            window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_VISIBLE);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);

        TourCatchDetailDto catchStatistics = statisticResponse.getTourCatchDetailDto();
        harborTxt.setText(catchStatistics.getLandingPort());
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat date = new SimpleDateFormat("dd MMM yyyy", new Locale("is"));
        String today = date.format(cal.getTime());
        dateOfTripTxt.setText(today);
        double totalWeight = catchStatistics.getCatchSum();
        totalCatchtxt.setText(getContext().getResources().getString(R.string.kg_txt, totalWeight));
        int mammalCount = 0;
        for (MammalAndBirdsTotalCatch mBTotalCatch : catchStatistics.getMammalAndBirdsTotalCatchList()) {
            mammalCount += mBTotalCatch.getCount();
        }
        totalMammalCatchTxt.setText(getContext().getResources().getString(R.string.mammal_and_bird_catch_count, mammalCount));
        totalSpeciesTxt.setText(String.valueOf((int) catchStatistics.getSpeciesCount()));
        totalRegistrationTxt.setText(String.valueOf((int) catchStatistics.getTotalPulls()));
        StatisticHelper.addLayouts(catchStatistics.getFishSpeciesTotalCatchList(),
                catchStatistics.getMammalAndBirdsTotalCatchList(),
                totalWeight, statisticsLayout, statisticsList, frag.getActivity());

        cancel_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismiss();
            }
        });

        finish_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismiss();
                stopTourListener.stopTourConfirmed();
            }
        });
    }
}

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

package is.stokkur.afladagbok.android.statistics.timePeriod;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.DatePicker;
import android.widget.TextView;

import java.util.Calendar;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.base.BaseFragment;
import is.stokkur.afladagbok.android.statistics.PageFragmentListener;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 11/22/17.
 */
@SuppressLint("ValidFragment")
public class TimePeriodStatisticsFragment
        extends BaseFragment
        implements DatePickerDialog.OnDateSetListener {

    @BindView(R.id.from_date)
    TextView fromDate;
    @BindView(R.id.to_date)
    TextView toDate;
    private View selectedTextView;
    public String dateFromSelected;
    public String dateToSelected;

    public TimePeriodStatisticsFragment() {
    }

    public TimePeriodStatisticsFragment(PageFragmentListener listener) {
        pageFragmentListener = listener;
    }

    public static TimePeriodStatisticsFragment newInstance(PageFragmentListener listener) {
        return new TimePeriodStatisticsFragment(listener);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.time_period_statistics_fragment, container, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @OnClick(R.id.from_layout)
    public void fromClicked(View view) {
        selectedTextView = view.findViewById(R.id.from_date);
        openDialog();
    }

    @OnClick(R.id.to_layout)
    public void toLayout(View view) {
        selectedTextView = view.findViewById(R.id.to_date);
        openDialog();
    }

    @OnClick(R.id.get_statistics_button)
    public void getStatistics() {
        if (pageFragmentListener != null && dateFromSelected != null && dateToSelected != null) {
            pageFragmentListener.onSwitchToNextFragment(dateFromSelected, dateToSelected);
        }
    }

    private void openDialog() {
        Calendar calendar = Calendar.getInstance();
        DatePickerDialog dialog = new DatePickerDialog(getActivity(), this,
                calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH),
                calendar.get(Calendar.DAY_OF_MONTH));
        dialog.show();
    }

    @Override
    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
        switch (selectedTextView.getId()) {
            case R.id.from_date:
                fromDate.setText(Utils.getSelectedDayAndYearFormatted(dayOfMonth, month, year));
                dateFromSelected = Utils.getYearMontDay(dayOfMonth, month, year);
                break;
            case R.id.to_date:
                toDate.setText(Utils.getSelectedDayAndYearFormatted(dayOfMonth, month, year));
                dateToSelected = Utils.getYearMontDay(dayOfMonth, month, year);
                break;
            default:
                fromDate.setText(Utils.getSelectedDayAndYearFormatted(dayOfMonth, month, year));
                dateFromSelected = Utils.getYearMontDay(dayOfMonth, month, year);
                break;
        }
    }

}

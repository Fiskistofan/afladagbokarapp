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

package is.stokkur.afladagbok.android.statistics.pastTours;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.History;
import is.stokkur.afladagbok.android.utils.Utils;

/**
 * Created by annalaufey on 12/6/17.
 */

public class PastTourAdapter extends RecyclerView.Adapter<PastTourAdapter.PastTourViewModel> {

    private List<History> pastTours;
    private Context context;
    private PastStatisticSelectListener listener;

    public PastTourAdapter(List<History> pastTours, Context context) {
        this.pastTours = pastTours;
        this.context = context;
    }

    @Override
    public PastTourViewModel onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.past_tour_item, parent, false);
        PastTourViewModel viewModel = new PastTourViewModel(view);
        return viewModel;
    }

    @Override
    public void onBindViewHolder(PastTourViewModel holder, int position) {
        History history = pastTours.get(position);
        holder.tourHarborText.setText(history.getLandingPortName());
        holder.tourDateText.setText(Utils.getFormattedStringFromDate(history.getDateLanded()));
        double totalWeight = history.getWeight(); // TODO: missing small
        holder.tourAmountText.setText(context.getResources().getString(R.string.fish_catch_kg, totalWeight));
        holder.tourLayoutItem.setOnClickListener(v -> listener.onSelectTour(history.getId()));
    }

    @Override
    public int getItemCount() {
        return pastTours.size();
    }

    public void setListener(PastStatisticSelectListener listener) {
        this.listener = listener;
    }

    public class PastTourViewModel extends RecyclerView.ViewHolder {

        @BindView(R.id.tour_harbor_text)
        TextView tourHarborText;
        @BindView(R.id.tour_layout_item)
        RelativeLayout tourLayoutItem;
        @BindView(R.id.tour_date_text)
        TextView tourDateText;
        @BindView(R.id.tour_amount_text)
        TextView tourAmountText;

        public PastTourViewModel(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }
}

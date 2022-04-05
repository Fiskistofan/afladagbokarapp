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

package is.stokkur.afladagbok.android.statistics.lastTrip;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.Catch;

/**
 * Created by annalaufey on 12/14/17.
 */

public class CatchStatisticAdapter extends RecyclerView.Adapter<CatchStatisticAdapter.CatchStatisticsViewModel> {

    private List<Catch> catches;
    private Context context;

    public CatchStatisticAdapter(List<Catch> catches, Context context) {
        this.catches = catches;
        this.context = context;
    }

    @Override
    public CatchStatisticsViewModel onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.fish_amount_item, parent, false);
        CatchStatisticsViewModel viewModel = new CatchStatisticsViewModel(view);
        return viewModel;
    }

    @Override
    public void onBindViewHolder(CatchStatisticsViewModel holder, int position) {
        holder.fishName.setText(catches.get(position).getName());
        holder.fishWeight.setText(context.getString(R.string.fish_catch_kg,
                catches.get(position).getAmount()));

        GradientDrawable drawable = (GradientDrawable) holder.colorView.getBackground();
        drawable.setColor(catches.get(position).getColor());
    }

    @Override
    public int getItemCount() {
        return catches.size();
    }

    public class CatchStatisticsViewModel extends RecyclerView.ViewHolder {

        @BindView(R.id.fish_name)
        TextView fishName;
        @BindView(R.id.fish_weight)
        TextView fishWeight;
        @BindView(R.id.color_view)
        View colorView;

        public CatchStatisticsViewModel(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }
}

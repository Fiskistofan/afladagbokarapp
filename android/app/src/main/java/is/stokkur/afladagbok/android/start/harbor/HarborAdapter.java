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

package is.stokkur.afladagbok.android.start.harbor;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import is.stokkur.afladagbok.android.R;
import is.stokkur.afladagbok.android.models.Port;

/**
 * Created by annalaufey on 11/29/17.
 */

class HarborAdapter
        extends RecyclerView.Adapter<HarborAdapter.HarborViewModel>
        implements Filterable {

    private final ArrayList<Port> mPorts = new ArrayList<>();
    private final ArrayList<Port> mFilteredPorts = new ArrayList<>();
    private final LayoutInflater mInflater;
    private final HarborSelectedListener selectedListener;

    private final Filter mFilter = new Filter() {
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String query = constraint != null ? constraint.toString().toLowerCase() : "";
            ArrayList<Port> filter = new ArrayList<>();

            if (query.isEmpty()) {
                filter.addAll(mPorts);
            } else {
                Port port;
                int size = mPorts.size();
                for (int i = 0; i < size; ++i) {
                    port = mPorts.get(i);
                    if (port.getPortName().toLowerCase().contains(query)) {
                        filter.add(port);
                    }
                }
            }

            FilterResults results = new FilterResults();
            results.values = filter;
            results.count = filter.size();
            return results;
        }

        @Override
        protected void publishResults(CharSequence constraint,
                                      FilterResults results) {
            mFilteredPorts.clear();
            //noinspection unchecked
            mFilteredPorts.addAll((ArrayList<Port>) results.values);
            notifyDataSetChanged();
        }
    };

    HarborAdapter(List<Port> harbors, Context context, HarborSelectedListener selectedListener) {
        mPorts.addAll(harbors);
        mFilteredPorts.addAll(harbors);
        mInflater = LayoutInflater.from(context);
        this.selectedListener = selectedListener;
    }

    @Override
    public HarborViewModel onCreateViewHolder(ViewGroup parent, int viewType) {
        return new HarborViewModel(mInflater.inflate(R.layout.harbor_item, parent, false));
    }

    @Override
    public void onBindViewHolder(HarborViewModel holder, int position) {
        Port port = mFilteredPorts.get(position);
        holder.harborName.setText(port.getPortName());
        holder.selectedHarbor.setOnClickListener(v ->
                selectedListener.selectHarbor(port.getId(), port.getPortName()));
    }

    @Override
    public int getItemCount() {
        return mFilteredPorts.size();
    }

    @Override
    public Filter getFilter() {
        return mFilter;
    }

    class HarborViewModel extends RecyclerView.ViewHolder {

        @BindView(R.id.harbor_detail_name)
        TextView harborName;

        @BindView(R.id.selected_harbor_layout)
        LinearLayout selectedHarbor;

        HarborViewModel(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }

    }

}

Return-Path: <linux-xfs+bounces-4180-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D548622B1
	for <lists+linux-xfs@lfdr.de>; Sat, 24 Feb 2024 06:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E62B22841D2
	for <lists+linux-xfs@lfdr.de>; Sat, 24 Feb 2024 05:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C331168CC;
	Sat, 24 Feb 2024 05:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tuLBCVtc"
X-Original-To: linux-xfs@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E5C125A6
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 05:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708751447; cv=none; b=IjtRnIe73shoj0nGVQGsgY8Xl4+z0DoK3o/4sHlm6++IkoDUiXGH65TzGEz6M1AKIPRsmWRyDrmOYC5mjFvG7EuVJJyravBN0Zn62ojNtcC5dvtMD7Rrm5gOenAPNW7kCgBY/fCtzjs0Ed6Zvh6T/uCNuWtddYhxcBd4sOH4ii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708751447; c=relaxed/simple;
	bh=2vD98sT+UQ2yQWG56xKXb7srFiVLS6GuDr6TzcoR/go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PIh4oxkwJevQi9t5R8regSjBIkNP9fZUBaUt0GusJmMoGvMU2ujw5HXBWuAmJEyOWK4igpaeFizdKNh3oSP1RHLjQP/ej6+Jev+McqF5w3FGK8HH1PUUHKCfV/Jf6gy62jjbXBs5Pg6S89pRSlU5lLdpU24GMscEC5sVJ2HEzBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tuLBCVtc; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 24 Feb 2024 00:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708751442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FwT1c3JSEQOWuaUP6z8lJns3QADyY2PvY4E2x0VTTzo=;
	b=tuLBCVtcSGFdCEuUEohXMOUMjK2i0SyBEYFVNe7wS9cDQFafwoEAjsHjrtrJOxQJ6zczNt
	hLWfzOtaJNUqZBVW4n5k1n4eQR4pZP9Itj9v8X+H52cDa0lE8hMKkjFzbcxbpBVlmV6eYQ
	2somZ+jRP1ysbvaY5H7LitwK2/1xoUM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: akpm@linux-foundation.org, daniel@gluo.nz, linux-xfs@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] time_stats: report information in json format
Message-ID: <hf4u56xx3riqz2wyx3qxqiidccocu6cs5z5qdla3zgo5v3wcbl@dldlaaamx2kn>
References: <170873667916.1860949.11027844260383646446.stgit@frogsfrogsfrogs>
 <170873668085.1860949.11659237532415596101.stgit@frogsfrogsfrogs>
 <20240224041545.GC616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240224041545.GC616564@frogsfrogsfrogs>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 23, 2024 at 08:15:45PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 23, 2024 at 05:12:26PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Export json versions of time statistics information.  Given the tabular
> > nature of the numbers exposed, this will make it a lot easier for higher
> > (than C) level languages (e.g. python) to import information without
> > needing to write yet another clumsy string parser.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  include/linux/time_stats.h |    2 +
> >  lib/time_stats.c           |   87 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 89 insertions(+)
> > 
> > 
> > diff --git a/include/linux/time_stats.h b/include/linux/time_stats.h
> > index b3c810fff963a..4e1f5485ed039 100644
> > --- a/include/linux/time_stats.h
> > +++ b/include/linux/time_stats.h
> > @@ -156,6 +156,8 @@ static inline bool track_event_change(struct time_stats *stats, bool v)
> >  struct seq_buf;
> >  void time_stats_to_seq_buf(struct seq_buf *, struct time_stats *,
> >  		const char *epoch_name, unsigned int flags);
> > +void time_stats_to_json(struct seq_buf *, struct time_stats *,
> > +		const char *epoch_name, unsigned int flags);
> >  
> >  void time_stats_exit(struct time_stats *);
> >  void time_stats_init(struct time_stats *);
> > diff --git a/lib/time_stats.c b/lib/time_stats.c
> > index 0fb3d854e503b..c0f209dd9f6dd 100644
> > --- a/lib/time_stats.c
> > +++ b/lib/time_stats.c
> > @@ -266,6 +266,93 @@ void time_stats_to_seq_buf(struct seq_buf *out, struct time_stats *stats,
> >  }
> >  EXPORT_SYMBOL_GPL(time_stats_to_seq_buf);
> >  
> > +void time_stats_to_json(struct seq_buf *out, struct time_stats *stats,
> > +		const char *epoch_name, unsigned int flags)
> > +{
> > +	struct quantiles *quantiles = time_stats_to_quantiles(stats);
> > +	s64 f_mean = 0, d_mean = 0;
> > +	u64 f_stddev = 0, d_stddev = 0;
> > +
> > +	if (stats->buffer) {
> > +		int cpu;
> > +
> > +		spin_lock_irq(&stats->lock);
> > +		for_each_possible_cpu(cpu)
> > +			__time_stats_clear_buffer(stats, per_cpu_ptr(stats->buffer, cpu));
> > +		spin_unlock_irq(&stats->lock);
> > +	}
> > +
> > +	if (stats->freq_stats.n) {
> > +		/* avoid divide by zero */
> > +		f_mean = mean_and_variance_get_mean(stats->freq_stats);
> > +		f_stddev = mean_and_variance_get_stddev(stats->freq_stats);
> > +		d_mean = mean_and_variance_get_mean(stats->duration_stats);
> > +		d_stddev = mean_and_variance_get_stddev(stats->duration_stats);
> > +	} else if (flags & TIME_STATS_PRINT_NO_ZEROES) {
> > +		/* unless we didn't want zeroes anyway */
> > +		return;
> > +	}
> > +
> > +	seq_buf_printf(out, "{\n");
> > +	seq_buf_printf(out, "  \"epoch\":       \"%s\",\n", epoch_name);
> > +	seq_buf_printf(out, "  \"count\":       %llu,\n", stats->duration_stats.n);
> > +
> > +	seq_buf_printf(out, "  \"duration_ns\": {\n");
> > +	seq_buf_printf(out, "    \"min\":       %llu,\n", stats->min_duration);
> > +	seq_buf_printf(out, "    \"max\":       %llu,\n", stats->max_duration);
> > +	seq_buf_printf(out, "    \"total\":     %llu,\n", stats->total_duration);
> > +	seq_buf_printf(out, "    \"mean\":      %llu,\n", d_mean);
> > +	seq_buf_printf(out, "    \"stddev\":    %llu\n", d_stddev);
> > +	seq_buf_printf(out, "  },\n");
> > +
> > +	d_mean = mean_and_variance_weighted_get_mean(stats->duration_stats_weighted, TIME_STATS_MV_WEIGHT);
> > +	d_stddev = mean_and_variance_weighted_get_stddev(stats->duration_stats_weighted, TIME_STATS_MV_WEIGHT);
> > +
> > +	seq_buf_printf(out, "  \"duration_ewma_ns\": {\n");
> > +	seq_buf_printf(out, "    \"mean\":      %llu,\n", d_mean);
> > +	seq_buf_printf(out, "    \"stddev\":    %llu\n", d_stddev);
> > +	seq_buf_printf(out, "  },\n");
> > +
> > +	seq_buf_printf(out, "  \"frequency_ns\": {\n");
> 
> I took the variable names too literally here; these labels really ought
> to be "between_ns" and "between_ewma_ns" to maintain consistency with
> the labels in the table format.
> 
> > +	seq_buf_printf(out, "    \"min\":       %llu,\n", stats->min_freq);
> > +	seq_buf_printf(out, "    \"max\":       %llu,\n", stats->max_freq);
> > +	seq_buf_printf(out, "    \"mean\":      %llu,\n", f_mean);
> > +	seq_buf_printf(out, "    \"stddev\":    %llu\n", f_stddev);
> > +	seq_buf_printf(out, "  },\n");
> > +
> > +	f_mean = mean_and_variance_weighted_get_mean(stats->freq_stats_weighted, TIME_STATS_MV_WEIGHT);
> > +	f_stddev = mean_and_variance_weighted_get_stddev(stats->freq_stats_weighted, TIME_STATS_MV_WEIGHT);
> > +
> > +	seq_buf_printf(out, "  \"frequency_ewma_ns\": {\n");
> > +	seq_buf_printf(out, "    \"mean\":      %llu,\n", f_mean);
> > +	seq_buf_printf(out, "    \"stddev\":    %llu\n", f_stddev);
> > +
> > +	if (quantiles) {
> > +		u64 last_q = 0;
> > +
> > +		/* close frequency_ewma_ns but signal more items */
> 
> (also this comment)
> 
> > +		seq_buf_printf(out, "  },\n");
> > +
> > +		seq_buf_printf(out, "  \"quantiles_ns\": [\n");
> > +		eytzinger0_for_each(i, NR_QUANTILES) {
> > +			bool is_last = eytzinger0_next(i, NR_QUANTILES) == -1;
> > +
> > +			u64 q = max(quantiles->entries[i].m, last_q);
> > +			seq_buf_printf(out, "    %llu", q);
> > +			if (!is_last)
> > +				seq_buf_printf(out, ", ");
> > +			last_q = q;
> > +		}
> > +		seq_buf_printf(out, "  ]\n");
> > +	} else {
> > +		/* close frequency_ewma_ns without dumping further */
> 
> (this one too)
> 
> Kent, would you mind making that edit the next time you reflow your
> branch?
> 
> --D
> 
> > +		seq_buf_printf(out, "  }\n");
> > +	}
> > +
> > +	seq_buf_printf(out, "}\n");
> > +}
> > +EXPORT_SYMBOL_GPL(time_stats_to_json);
> > +
> >  void time_stats_exit(struct time_stats *stats)
> >  {
> >  	free_percpu(stats->buffer);
> > 
> > 


From 5885a65fa5a0aace7bdf1a8fa58ac2bca3b15900 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Sat, 24 Feb 2024 00:10:06 -0500
Subject: [PATCH] fixup! time_stats: report information in json format


diff --git a/lib/time_stats.c b/lib/time_stats.c
index 0b90c80cba9f..d7dd64baebb8 100644
--- a/lib/time_stats.c
+++ b/lib/time_stats.c
@@ -313,7 +313,7 @@ void time_stats_to_json(struct seq_buf *out, struct time_stats *stats,
 	seq_buf_printf(out, "    \"stddev\":    %llu\n", d_stddev);
 	seq_buf_printf(out, "  },\n");
 
-	seq_buf_printf(out, "  \"frequency_ns\": {\n");
+	seq_buf_printf(out, "  \"between_ns\": {\n");
 	seq_buf_printf(out, "    \"min\":       %llu,\n", stats->min_freq);
 	seq_buf_printf(out, "    \"max\":       %llu,\n", stats->max_freq);
 	seq_buf_printf(out, "    \"mean\":      %llu,\n", f_mean);
@@ -323,14 +323,14 @@ void time_stats_to_json(struct seq_buf *out, struct time_stats *stats,
 	f_mean = mean_and_variance_weighted_get_mean(stats->freq_stats_weighted, TIME_STATS_MV_WEIGHT);
 	f_stddev = mean_and_variance_weighted_get_stddev(stats->freq_stats_weighted, TIME_STATS_MV_WEIGHT);
 
-	seq_buf_printf(out, "  \"frequency_ewma_ns\": {\n");
+	seq_buf_printf(out, "  \"between_ewma_ns\": {\n");
 	seq_buf_printf(out, "    \"mean\":      %llu,\n", f_mean);
 	seq_buf_printf(out, "    \"stddev\":    %llu\n", f_stddev);
 
 	if (quantiles) {
 		u64 last_q = 0;
 
-		/* close frequency_ewma_ns but signal more items */
+		/* close between_ewma_ns but signal more items */
 		seq_buf_printf(out, "  },\n");
 
 		seq_buf_printf(out, "  \"quantiles_ns\": [\n");
@@ -345,7 +345,7 @@ void time_stats_to_json(struct seq_buf *out, struct time_stats *stats,
 		}
 		seq_buf_printf(out, "  ]\n");
 	} else {
-		/* close frequency_ewma_ns without dumping further */
+		/* close between_ewma_ns without dumping further */
 		seq_buf_printf(out, "  }\n");
 	}
 


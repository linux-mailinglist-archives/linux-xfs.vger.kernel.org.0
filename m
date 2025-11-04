Return-Path: <linux-xfs+bounces-27472-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B417EC32293
	for <lists+linux-xfs@lfdr.de>; Tue, 04 Nov 2025 17:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79E78424834
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Nov 2025 16:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F049333769A;
	Tue,  4 Nov 2025 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfIR708V"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5552295D90
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275245; cv=none; b=YeugY54TTD8SVao7gY71AO8Cv2Ws3SErqNv/zDC6ieFW/pUm2HMth0KVmq6ihgsvAy+9/M02tGSWvKdAZityzWN4eE+e69y+kUx0JzQknuioaVKdQ6TJN97PdpDktdvd0RFC+OYYDGlLeF96nvI0RPmcR6E9DVVgPPqTZT+uAlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275245; c=relaxed/simple;
	bh=UT/GxCkDmxuQrULgdM/YKvKGv/0t6tOlbhIhP+SJiy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMHjTQ6CGXJ54DjwCvXawKFbA89sfXPsLYh1Mja/rpiFnr8p70YXFhaT3kT9VkLhDW3bgEPPqlzl6N2lcww9TruDh7Rvo2aWY3bGBZ4QACkw0k80e58nV43xQAAQWc4SwKreFcCDR/1Z79c8/N3n06EHGaHyqzk/0n3PGJTorlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfIR708V; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3EEC4CEF7;
	Tue,  4 Nov 2025 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762275244;
	bh=UT/GxCkDmxuQrULgdM/YKvKGv/0t6tOlbhIhP+SJiy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jfIR708VncPslHKc/yAFamd6l+IDBJ3yzGzBt7Bg5XOZU+c4/N1wdi+2Nnc1AMzV8
	 6edAe7TGHlpw6uLHegzbm4HezwGTss5AfAiVV/FSYSeC5qrAYt5kHzU4d0wE5CdU08
	 aBf4ESDtEYvWJLr0w4gMHXeShm7ACZtk4KJ4JK2Zj2KPoZNxqJASfEjQHITq4MdlXF
	 X9d4ne1j4Ph4bLsdDlb58PCX9eQp5uekaXf7YD44r6HwhB8xzpMv/S5PTVAv9/L27o
	 3l5gWagvmPwzLy07HxttxRwFhDkGVP7zsjZZOEPSxSsYjf4Uq7dBrcuKJOCJnA1R1x
	 U1XOhUR4quT7Q==
Date: Tue, 4 Nov 2025 08:54:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 1/2] libfrog: Prevent unnecessary waking of worker thread
 when using bounded workqueues
Message-ID: <20251104165404.GG196370@frogsfrogsfrogs>
References: <20251104091439.1276907-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091439.1276907-1-chandanbabu@kernel.org>

On Tue, Nov 04, 2025 at 02:44:36PM +0530, Chandan Babu R wrote:
> When woken up, a worker will pick a work item from the workqueue and wake up
> another worker when the current workqueue is a bounded workqueue and if there
> is atleast one more work item remains to be processed.
> 
> The commit 12838bda12e669 ("libfrog: fix overly sleep workqueues") prevented
> single-threaded processing of work items by waking up sleeping workers when a
> work item is added to the workqueue. Hence the earlier described mechanism of
> waking workers is no longer required.
> 
> Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

That makes sense to me, sorry for forgetting to remove this hunk.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/workqueue.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
> index db5b3f68b..9384270ff 100644
> --- a/libfrog/workqueue.c
> +++ b/libfrog/workqueue.c
> @@ -51,10 +51,6 @@ workqueue_thread(void *arg)
>  		wq->next_item = wi->next;
>  		wq->item_count--;
>  
> -		if (wq->max_queued && wq->next_item) {
> -			/* more work, wake up another worker */
> -			pthread_cond_signal(&wq->wakeup);
> -		}
>  		wq->active_threads++;
>  		pthread_mutex_unlock(&wq->lock);
>  
> -- 
> 2.45.2
> 
> 


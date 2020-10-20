Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A592728CC2C
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Oct 2020 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgJMLEp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Oct 2020 07:04:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727097AbgJMLEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 07:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602587083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LTobc4urk2UcGr9I3nYqZdD7A/v35qH7FlcGA5wIjGI=;
        b=IT4+1y61yoQJHZJEsEOTYVG1Goi89RU951rfPhtUmFJ7fwXZXVk7raSXVxGWeclLuzzBUU
        wEoO5q5/j7tAhoQDRy4w+Wl16ToeWzE6Om84nIgJtim2SVQPJ65ptNACPSYoOJ2FJa2Xwj
        iMbgaMAhkti/8K5fizQsohxd15yZjAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-GmEVGFnVOgWDEd14PLb8SA-1; Tue, 13 Oct 2020 07:04:30 -0400
X-MC-Unique: GmEVGFnVOgWDEd14PLb8SA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C50080B71A
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2020 11:04:29 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF84D5578D;
        Tue, 13 Oct 2020 11:04:28 +0000 (UTC)
Date:   Tue, 13 Oct 2020 07:04:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201013110427.GB966478@bfoster>
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com>
 <20201012160412.GK917726@bfoster>
 <ffc87f66-759d-ac3c-5749-0972aa41924f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffc87f66-759d-ac3c-5749-0972aa41924f@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 10:44:38PM +0200, Pavel Reichl wrote:
> 
> 
> On 10/12/20 6:04 PM, Brian Foster wrote:
> > ...
> >> @@ -2863,8 +2875,20 @@ xfs_btree_split(
> >>  	args.done = &done;
> >>  	args.kswapd = current_is_kswapd();
> >>  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> >> +	/*
> >> +	 * Update lockdep's ownership information to reflect that we
> >> +	 * will be transferring the ilock from this thread to the
> >> +	 * worker.
> >> +	 */
> > 
> > Can we update this comment to explain why we need to do this? E.g., I'm
> > assuming there's a lockdep splat somewhere down in the split worker
> > without it, but it's not immediately clear where and so it might not be
> > obvious if we're ever able to remove this.
> 
> Hi, would something like this work for you?
> 
> 	/*
> +	 * Update lockdep's ownership information to reflect that we
> +	 * will be transferring the ilock from this thread to the
> +	 * worker (xfs_btree_split_worker() run via queue_work()).
> +	 * If the ownership transfer would not happen lockdep would
> +	 * assert in the worker thread because the ilock would be owned
> +	 * by the original thread.
> +	 */
> 

That doesn't really answer the question. Do you have a record of the
lockdep error message that occurs without this state transfer, by
chance?

Brian

> 


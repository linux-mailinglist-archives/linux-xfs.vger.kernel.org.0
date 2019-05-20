Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B6C237FA
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbfETNZq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:25:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18195 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729963AbfETNZq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:25:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A40B7EBC1;
        Mon, 20 May 2019 13:25:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5E4078392;
        Mon, 20 May 2019 13:25:45 +0000 (UTC)
Date:   Mon, 20 May 2019 09:25:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/20] xfs: use a list_head for iclog callbacks
Message-ID: <20190520132543.GL31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-12-hch@lst.de>
 <20190520131232.GB31317@bfoster>
 <20190520131946.GA8717@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190520131946.GA8717@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 20 May 2019 13:25:46 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 03:19:46PM +0200, Christoph Hellwig wrote:
> On Mon, May 20, 2019 at 09:12:33AM -0400, Brian Foster wrote:
> > > +				spin_unlock(&iclog->ic_callback_lock);
> > > +				xlog_cil_process_commited(&tmp, aborted);
> > 
> > s/commited/committed/ please.
> 
> Ok.
> 
> > > +	while ((ctx = list_first_entry_or_null(list,
> > 
> > Are double braces necessary here?
> 
> Without them gcc is unhappy:
> 
> fs/xfs/xfs_log_cil.c: In function ‘xlog_cil_process_commited’:
> fs/xfs/xfs_log_cil.c:624:9: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
>   while (ctx = list_first_entry_or_null(list,
> 

Ok, wasn't quite sure if that mattered.

Brian

> > >  	/* attach all the transactions w/ busy extents to iclog */
> > 
> > Any idea what this ^ comment means? ISTM it's misplaced or stale. If so,
> > we might as well toss/replace it.
> 
> No idea.  We can probbaly remove it.

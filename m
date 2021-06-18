Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E843ACC48
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Jun 2021 15:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhFRNgD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 18 Jun 2021 09:36:03 -0400
Received: from verein.lst.de ([213.95.11.211]:34929 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232253AbhFRNgB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 09:36:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D162568D08; Fri, 18 Jun 2021 15:33:50 +0200 (CEST)
Date:   Fri, 18 Jun 2021 15:33:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: factor out a xlog_write_full_log_vec helper
Message-ID: <20210618133350.GC13406@lst.de>
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-8-hch@lst.de> <YMt3OpN3M95p4qHe@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMt3OpN3M95p4qHe@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 12:24:26PM -0400, Brian Foster wrote:
> > +{
> > +	int			i;
> > +
> > +	ASSERT(*log_offset + *len <= iclog->ic_size ||
> > +		iclog->ic_state == XLOG_STATE_WANT_SYNC);
> 
> I suspect this could be lifted into the original caller (xlog_write())
> since it doesn't have much to do with the current lv (and this is
> eventually no longer called for each lv in the chain)..? Otherwise the
> patch LGTM.

Yes, I guess we should just move it before the main loop over the lv
in the next patch and just keep it where it is for now.  That will
remove the additional invocations if we switch back from partial
to simple iclog writes, but given that len and log_offset are updated
together the extra asserts are rather pointless anyway.

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C209117DA29
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Mar 2020 09:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgCIIDT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Mar 2020 04:03:19 -0400
Received: from verein.lst.de ([213.95.11.211]:46547 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCIIDT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Mar 2020 04:03:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 751D568B20; Mon,  9 Mar 2020 09:03:17 +0100 (CET)
Date:   Mon, 9 Mar 2020 09:03:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: remove the aborted parameter to
 xlog_state_done_syncing
Message-ID: <20200309080317.GB31481@lst.de>
References: <20200306143137.236478-1-hch@lst.de> <20200306143137.236478-5-hch@lst.de> <20200306171201.GG2773@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306171201.GG2773@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 12:12:01PM -0500, Brian Foster wrote:
> >  out_abort:
> > -	xlog_cil_committed(ctx, true);
> > +	xlog_cil_committed(ctx);
> 
> Error paths like this might warrant an assert. It's not really clear
> that we expect to be shutdown based on the context. Otherwise looks Ok.

I've added an assert to the next version.

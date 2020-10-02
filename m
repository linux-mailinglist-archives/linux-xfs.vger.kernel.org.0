Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B50280DF3
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Oct 2020 09:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgJBHQ1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Oct 2020 03:16:27 -0400
Received: from verein.lst.de ([213.95.11.211]:51305 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgJBHQ1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 03:16:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6653167357; Fri,  2 Oct 2020 09:16:25 +0200 (CEST)
Date:   Fri, 2 Oct 2020 09:16:25 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH 2/5] xfs: remove XFS_LI_RECOVERED
Message-ID: <20201002071625.GA9900@lst.de>
References: <160140139198.830233.3093053332257853111.stgit@magnolia> <160140140527.830233.8494766872686671838.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140140527.830233.8494766872686671838.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:43:25AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The ->iop_recover method of a log intent item removes the recovered
> intent item from the AIL by logging an intent done item and committing
> the transaction, so it's superfluous to have this flag check.  Nothing
> else uses it, so get rid of the flag entirely.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

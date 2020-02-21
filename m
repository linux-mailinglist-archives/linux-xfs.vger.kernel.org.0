Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5171680DA
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgBUOxz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:53:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55624 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbgBUOxz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NKePb6Fl4XnYyHoNwBTZgie9VWGckrdrX7feDxVWPoE=; b=bwL+KUF1N8Kx+zxlG2r/fV9mOU
        dSZnlrWexE2eswuKs1IhVHiarSvVc2hTEja2sx7w/1p6E1tqn7syYIQ9VDoB2622ksWUun0jbdoce
        L4rN0vQ6qGl7FNavnWwzDpTNtclbD/ofi2Lz/unOdyc7mfz5P8AQCiT9kCdJqc43J6lrgTPkcub8v
        5TWX8xMpYsTehXVR8zuY+otokCWejaQQOrM1OgrEfcxfiFcG0y8FxjlapxAim0xtk2mwEqNjJBuxJ
        yH3mzq+nRPGs8Tc5lqX/7sLFWGDJbIk6qochgkd/MWd8QGkhG06qgorrqJauZZUzgpsjtizZd9cOD
        EasMguyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59gg-0003VR-AE; Fri, 21 Feb 2020 14:53:54 +0000
Date:   Fri, 21 Feb 2020 06:53:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/18] libxfs: hide libxfs_{get,put}bufr
Message-ID: <20200221145354.GM15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216304905.602314.17780460003947176973.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216304905.602314.17780460003947176973.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hide these two functions because they're not used outside of rdwr.c.

Can we also pick a better name?  That r postfix always seem very strange
to me.

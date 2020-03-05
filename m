Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F7017AA1C
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2020 17:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCEQFX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Mar 2020 11:05:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCEQFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 11:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=g3eg4+EIniuIAfHTr3M1idR+8fwUjsxGz8vHIDmJ4/c=; b=EVP3dWBW0AuMYM67yNMva6hDx1
        XOljdLgyr4BLX6fI/2/t+lJ8Y2eGpfqc4uES6dInaaHu+g4STPVcpdcLJCWl6mcSMCCd2+jZHH3wB
        h1Xq4ObnMJgeSYj63t8i8/qBIaWLWV3lEXes/2i3V5jh86zIgr+hkyJkG38dfBh7LTmX7o5vEA3a0
        OFvWkxuHuBMV/UdA5dLqmdA3rovbMeCOcvR7susugReagfM62BDOSMH3uxf+RUTc/fD1mnGWjFsap
        azuj09/S5k3WgoFzzsIoU2CYplWpX4krfLnnGQ9gh4sMyy5dpvBfXHOSdlCyI8AeDhKGElBGRFXsM
        vUlU9/Ig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9szy-0002ZC-KS; Thu, 05 Mar 2020 16:05:22 +0000
Date:   Thu, 5 Mar 2020 08:05:22 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/11] xfs: clean up log tickets and record writes
Message-ID: <20200305160522.GA4825@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, I'd prefer to just see the series without patches 6, 7 and 9 for
now.  They aren't really related to the rest, and I think this series:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-kill-XLOG_STATE_IOERROR

has a better approach to sort out those areas.  The rest looks really
good to me modulo minor cleanups here and there.

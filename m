Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67798179415
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 16:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgCDPvk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 10:51:40 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgCDPvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:51:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=msa8BPz6CWDOkNJ/6LYFEAI4QfLhsWzwOwSkRvBrOus=; b=QNgkWYZf5rtedAo4DxdBhx68Pb
        4jYReHZ/m8+j9qxhav/pELnrOKdDOYtEIdEFlNqnvIYBxP3qWMuvumMQf5Eu6RZ1okZWilcfB5tUh
        tIyp8v6cuALAHHPtZB///G7nU+gJTdGC4+nXUcsRHqSflfSigomjqI/dtwn7f8Bp8YfZqy/stiQP2
        FCtM33RFzs+sJPZpg0TxbmdjdQKH+UIz06FJXx+DXbsNe0Gu7i6T/KquY3B1GS9t5LuOsiWtfwDU5
        14IAhKpIZ9VRJPuAXzwWJJwk8eJzlqPA7yzvxEN+7uIpZCOxcLaj1fhjw61SuB3qwYn5D8l057YKm
        RoStZ6Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WJA-0001rZ-6w; Wed, 04 Mar 2020 15:51:40 +0000
Date:   Wed, 4 Mar 2020 07:51:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: move xlog_state_ioerror()
Message-ID: <20200304155140.GE17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-7-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:56PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To clean up unmount record writing error handling, we need to move
> xlog_state_ioerror() higher up in the file. Also move the setting of
> the XLOG_IO_ERROR state to inside the function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

FYI, I have a pending series that kills xlog_state_ioerror and
XLOG_IO_ERROR.  Let me send that out now that Brians fix is in for-next.

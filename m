Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD27161409
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgBQN5M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:57:12 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgBQN5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SPXMXoalsASZ0GP51EJX0T1WNPN5lLXWpirmM+LNwb8=; b=NI+7x7RvwlMn/LB1PF1kkXE0ZQ
        1GIkdZsfWFUXb2DvUL9jjzgcrlVJ/YTg5D068XCq5Oa7i+/XPjl2OlMBzw8Vig1ZhLtF5RMg6czEM
        koYs7FrdJ+UuK6X8yhAC4HCPxZ9Guzav0MDlJ4lPNAXjOF+kweKGu876YY5QJOYuNe6XJLhJ2lm4Y
        eVcQ27P8kT6hDx7lPx4ctdgnjYfjgPSRKojvoWamRg//pJGNwVArJB5Y5kYXVYYST9Cd3gMbiYfCr
        oBOeUjFQxLGxuWIDMn00I+e+Tc5Xxgvm0VE9eGipsa9fSPfDv3u/iqggTKMou/josQB1iYqSM+8Pc
        tLTRgOGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3gtb-0003fa-Pi; Mon, 17 Feb 2020 13:57:11 +0000
Date:   Mon, 17 Feb 2020 05:57:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: libxfs_buf_delwri_submit should write
 buffers immediately
Message-ID: <20200217135711.GL18371@infradead.org>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086365123.2079905.12151913907904621987.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086365123.2079905.12151913907904621987.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But can we come up with a better name and description for
libxfs_writebufr? and libxfs_writebuf?

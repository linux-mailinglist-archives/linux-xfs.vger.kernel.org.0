Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB02CEBDF
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Dec 2020 11:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgLDKJ6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Dec 2020 05:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgLDKJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 05:09:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456FC0613D1
        for <linux-xfs@vger.kernel.org>; Fri,  4 Dec 2020 02:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=HaGyiS7J1blIibU4G7Pcg3+Kk6
        NfzqHXDfgMp/tNT8KfNQBlOJNG/BX/xBQrVvuhxFbFWANRhNi7qkVutUMyLV9Jql9+i0btPrOIUcj
        L2WtPYe8QF+g7gKDVL9vILl2zWFfw9Ck5Nc5jg+6hXyuv3wFe/iRV+VWZxNdeYFHh6LHTyP7bm8aQ
        2skh5RdyLeg73CNHxGO8SPkSlEpOOIErtWcCKnvBR4u7+LeX0HnZSOndw7p6UvrIVNsZA0ZHtjx7u
        lK+NScB2UmZ3ZwQnugbEd9pn9rHzuq6TI9DD8uzl02xpI9BZjuEQx+TzON3k2r9tCYbRhZSOXgaxj
        rRp7aG6Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kl81a-0000XS-UP; Fri, 04 Dec 2020 10:09:14 +0000
Date:   Fri, 4 Dec 2020 10:09:14 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: detect overflows in bmbt records
Message-ID: <20201204100914.GA1734@infradead.org>
References: <160704436050.736504.11280764290946254498.stgit@magnolia>
 <160704437017.736504.13199098088562847416.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704437017.736504.13199098088562847416.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

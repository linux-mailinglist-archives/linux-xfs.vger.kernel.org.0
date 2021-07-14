Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32573C7E6E
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 08:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbhGNGSe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 02:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbhGNGSe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 02:18:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99971C0613DD
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 23:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=m/gWTNCr3HwLJ/Ai/jgSwGT2KY
        gNoCizyK/92hBWH8pfOHMiEcdWlR1U+mL1nNepPqf4JQn3Yqj3dJ3OdJ3Am/qmv+JN/9rvyWBbaDC
        n6Qs97D65++UQ5IjxXS3JzSv9JtdO9w24jkAkuk4TxYb9NdOVQschZc82afCJPQURpfl2igxDRfMU
        WpxjAYH7i0EF+IxS3sVmPl+cVOvbQ1v2AnjO37Ch7EpJ8gXnAF1EQpSNu3fHp12Fhhk85eX2Pzjrl
        wPJmOUiCFEA9TOiHU5E9z7Kk+ehIjQsTcad6nGBvg90TzQeEZDkvLljC4KV7/B/wKpHIry/6r/4lw
        bfHiVnJw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3YAr-001ukz-RA; Wed, 14 Jul 2021 06:15:21 +0000
Date:   Wed, 14 Jul 2021 07:15:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: make forced shutdown processing atomic
Message-ID: <YO6A8TchC/OE6T0P@infradead.org>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

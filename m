Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C444926D5AA
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 10:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgIQIHC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 04:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIQIHB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:07:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09C5C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nzYqg4un7ZogVzx/BOOSDpoaseFl/bJUvzQuUcmWeV8=; b=uGiCRclsB+wKx6NJ2UV7/BlN9O
        cPM8RLd1fARkeMGeb9QO3JCHCzn6mQ0e8DMCYvBbVkwCWFQZ7PZ+xZjWE5IWa/s9rndzjmglcuBKZ
        nmt3VN20LayHOe8kwkPXnvwcaWnwp4GQ4iZ/gEA6MC+IuGzhbmqo71ZrpEjhyC45TysckcqVkIZ7y
        kqdKdhQEr+F+mDOZ4wbBSSxyvorq8Qo7CcK0G0YgdXheQBwkVAp+Y0K564T6PRIXR497hw0ZaDqEW
        DNxewU83Uji8bD5ThJ7mQgyf5o20w/OcrGBvDhyQ3TWDUdgm6gA7NOeX+DDcnjWbpcNyfm1k9AJkO
        SLRHAk6Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIowL-000885-5L; Thu, 17 Sep 2020 08:06:49 +0000
Date:   Thu, 17 Sep 2020 09:06:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: use the existing type definition for di_projid
Message-ID: <20200917080649.GZ26262@infradead.org>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-3-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:19:05PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We have already defined the project ID type prid_t, so maybe should
> use it here.

Looks ok, but I have a long pending series I need to resubmit to
kill of xfs_icdinode, for which this would just create churn..

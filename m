Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C26188D87
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 19:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCQS7D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Mar 2020 14:59:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCQS7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 14:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o1jSNdKh3P5/mg7EfYTph4G29M5hJOPuE7K25pl7G1o=; b=Br9SuJBS0VbRkpiAaG/FAEMWN0
        ucpsv1Y93MIa5f+8id5bqNf0kOsecB2SRFRIKxId8r8Mc+cB+S2jAZ9X6no57mlhfQKWd1K0lPoW9
        SKJsdkXdvcFcwvQI+Vob0Rr/CY6URmW4XuTtrdpubNqH4KIxrHO5tnBfI1Po6mBBpjM9JSE1yxEbu
        JoPcvIN9ufmgvERO37NrqjXl9dSJOk/QvfVuA2ZOfOBZ0e1zZy1t4DQ1tmxXb/DJ+3PQg/xVtgsae
        TnJIPiT1eRAJomd3Jv5myelbaXhwlbfbu7qBwI+SLhYOl03pKG5YiZRzTOjpH1Hq96CG3ViTccsCM
        VNlwyKsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHQL-0001A8-85; Tue, 17 Mar 2020 18:58:45 +0000
Date:   Tue, 17 Mar 2020 11:58:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: use more suitable method to get the quota limit
 value
Message-ID: <20200317185845.GA4168@infradead.org>
References: <1584439170-20993-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584439170-20993-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 05:59:30PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> It is more suitable to use min_not_zero() to get the quota limit
> value, means to choose the minimum value not the softlimit firstly.
> And the meaning is more clear even though the hardlimit value must
> be larger than softlimit value.

Suitable seems like a rather overblown word, but the actual change looks
fine to me, min_not_zero has grown on me..

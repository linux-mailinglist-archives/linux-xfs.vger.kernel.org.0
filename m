Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA0912A153
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Dec 2019 13:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfLXMa0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Dec 2019 07:30:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfLXMaZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:30:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=juS2oafXcu3CZQqDGgJ1Zl4mpL7Ek4aDHmHidCfy9MA=; b=ehbL66qXpGP+bvGKkYQUAqoDn
        ZkMZdXVBK6KYroTHo9d/TwTeQpnPkWbDOVnCsCGKv3BHWIbQCEBSQpFoU7ew/qbarKeE+6oDN0sn+
        1f0QNdS5MA8kiN1seytGyxikgD+mlJbcwrfYsXougrch38i1MZK0LPegSJEwW786F6aHflKccDE4I
        S7Tm1pYOPCZWmS+2n8EolhIhNL6XFrvvju9y0bcLuX+uJVmMqUshdP00vFONhAKn/XEdfVSYBuKja
        0Vkv5gPCkONg4MghIaVIH9JeCnQxaZn7CLNcJN5j8u7APB6S2OCfMoK7neuh1IlRdO8DvlrYREyWQ
        cPZG1qUVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijjKT-0008K6-P2; Tue, 24 Dec 2019 12:30:25 +0000
Date:   Tue, 24 Dec 2019 04:30:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 13/14] xfs: Add delay ready attr remove routines
Message-ID: <20191224123025.GI18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-14-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-14-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This code looks pretty scary, mostly because it adds hard to parse
monster functions.  Also as-is it seems totally pointless as no
user of the change appears.  In fact this series adds almost 500
lines of code without adding any code or speeding operations up (in
fact I think it will cause minor slow downs).  So to me it is a very
hard sell.

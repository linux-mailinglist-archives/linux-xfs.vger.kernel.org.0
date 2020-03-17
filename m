Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CCF188DDA
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 20:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgCQTTz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Mar 2020 15:19:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQTTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 15:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vNztYUUB+kavG/NJyfN0YEr3SFgngZL+J+c7khTjYSQ=; b=QAsCjFUz7Xwp2nrOGvDqfMsd2O
        XZ+l2ek5mKvTCZFQDoo74zXhAmRi0yQ/jSowVi5+UmiNOPt6LGzWd/1jNkJr8BXpAyqmPs/YxpkW9
        +kzeesFYs9O2FrngH0RbYg3E6tLCp0/2LfWKmWn3C4ssm0SkgGDuIivEqQ0RUa+/i2C2zBpAfbZgR
        2Rxsf/66wyfKhYJYReKoYcgJOCfhGquIJl7J6cq767pXvNvIqYW++VG5ZziKdMWdZewhM0/zgxcLQ
        XnrMBOV4LmkuqVtRIO9kTIYQAAw0KfZnifXeepxFmKIoiaSUoTezkj6WBoBfSFq/qA4g+ZvZT3wTE
        9Z4oajRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHko-0007rx-Sk; Tue, 17 Mar 2020 19:19:54 +0000
Date:   Tue, 17 Mar 2020 12:19:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Ober, Frank" <frank.ober@intel.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: write atomicity with xfs ... current status?
Message-ID: <20200317191954.GA29982@infradead.org>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Atomic writs are still waiting for more time to finish things off.

That being said while I had a prototype to use the NVMe atomic write
size I will never submit that to mainline in that paticular form.

NVMe does not have any flag to force atomic writes, thus a too large
or misaligned write will be executed by the device withour errors.
That kind of interface is way too fragile to be used in production.

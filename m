Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214AC77C19
	for <lists+linux-xfs@lfdr.de>; Sat, 27 Jul 2019 23:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfG0VjW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 27 Jul 2019 17:39:22 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:35253 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725263AbfG0VjW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 27 Jul 2019 17:39:22 -0400
Received: from [192.168.1.19] (x590ebd28.dyn.telefonica.de [89.14.189.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id B56D5201A3C24;
        Sat, 27 Jul 2019 23:39:19 +0200 (CEST)
Subject: Re: Unmountable XFS file system after runnig stress-ng
To:     Rob Townley <Rob.Townley@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <b92674c4-488e-15ec-2052-eb69e4f80b7e@molgen.mpg.de>
 <20190727002439.GS30113@42.do-not-panic.com>
 <CA+VdTb8ZPLi0Eiq9SEhem4aEjWJ3rCn+NQ_vZrpc9mXo_WuDDQ@mail.gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <adc3bb44-b9ea-adc7-9314-dd5c0828fb66@molgen.mpg.de>
Date:   Sat, 27 Jul 2019 23:39:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+VdTb8ZPLi0Eiq9SEhem4aEjWJ3rCn+NQ_vZrpc9mXo_WuDDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear Rob,


On 27.07.19 13:34, Rob Townley wrote:
> Is there ECC RAM in this PC?
> 
> “Corruption of in-memory data detected.  Shutting down filesystem“

Yes, there is ECC memory in that system.


Kind regards,

Paul

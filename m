Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA34AB41
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 21:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfFRT7G (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 15:59:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36270 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbfFRT7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 15:59:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so23470199edq.3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2019 12:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sQSgJAjLDUfYJVN8p2nmbHNvJ620shYzyizmv3V8JUU=;
        b=Hz7fj+eeUk5M4wxw4x1+p77GKbpGLx3JyJIG8OUg1r90i00LVelAL9n6PXAVmd3R+M
         7GeRMtNqRnwoQKxGZDjEPFcdQC4570Sm+PiD8R79Q7ry6RTOZK5iMW6vFPt6cuR+wwB3
         ESH/yBS++ej1r78E4RO2vV6qiMux8w5vBU6n0BeVprwuFxI7Jq87sL/oDgFBL1/Iud1+
         8JLdq7WauQRClNk97GTF7ThHQq/K57i/P0ad9ih/7idH5NAeGyi4YYyaanap1cqsJDIx
         0/67J3HVQ/qQ8DiATFBuOvdOjqvI9kptXhsk3YwQ218UpyP3V17Y1o6vGrCYdzCvj6Ze
         4csA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sQSgJAjLDUfYJVN8p2nmbHNvJ620shYzyizmv3V8JUU=;
        b=BjATEqd/U3+H+KPGowXkvoW1ZI1RS/aplg2lWHrrK3hKEojU6M6Egi0XU7IreDFCBN
         +rWd0Z8itb32V/aBITC+TAeDSnlUIPyYfCmBgBEH9WpY7BfEoFsgYscp4fiSdS8eHYdN
         dnyQSMe/iVWJ3shm68QbGbC25XDmtu5dktH2aumrFSd4OBsliGNgCsHWl15lzhYH0wyv
         NFCtku4P7fn1aGexk/ZbGbrjnMpBCuF65oj/j9W1bI7EdZkm+Ciyjbtgrztq6YDJnITl
         heLzHyp8LpUmJiIjt9nPdQq40hRXDDD2rlE5UeDKf1sXvX/WTQOV9cWrwBKhIjabUCaL
         QRBA==
X-Gm-Message-State: APjAAAXY5FhMSG1Y4mxdjo3Uds2W9FX5eskBm3UXAkJmZ1kGrZtqhV/b
        GSkTBIcjWx5G9k6oG9bWUKnHhN2OZiNGd+Ea
X-Google-Smtp-Source: APXvYqzdtIP/ZzxxJ+541H7ZPhjoD7PDBf2h/dIDP7K8BvafUUrmOFD9+siKP6OgGEYIILG3FVx48Q==
X-Received: by 2002:a50:9116:: with SMTP id e22mr94145395eda.161.1560887944715;
        Tue, 18 Jun 2019 12:59:04 -0700 (PDT)
Received: from [192.168.0.115] (xd520f250.cust.hiper.dk. [213.32.242.80])
        by smtp.gmail.com with ESMTPSA id x21sm2914652edb.0.2019.06.18.12.59.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 12:59:04 -0700 (PDT)
Subject: Re: same page merging leak fix v4
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20190617091412.15923-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35950338-41e9-447c-d534-de735d5ffca5@kernel.dk>
Date:   Tue, 18 Jun 2019 13:59:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617091412.15923-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/17/19 3:14 AM, Christoph Hellwig wrote:
> Hi Jens, hi Ming,
> 
> this is the tested and split version of what I think is the better
> fix for the get_user_pages page leak, as it leaves the intelligence
> in the callers instead of in bio_try_to_merge_page.

Applied, thanks.

-- 
Jens Axboe

